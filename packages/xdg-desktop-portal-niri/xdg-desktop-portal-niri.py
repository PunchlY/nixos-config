#!/usr/bin/env python

import asyncio
import os

from dbus_next.aio import MessageBus
from dbus_next.service import ServiceInterface, method
from dbus_next.signature import Variant

DBUS_NAME = "org.freedesktop.impl.portal.desktop.niri"


async def run_picker(options):
    return options[0] if options else None


def find_desktop_entry(name):
    return {"name": name, "exec": ["xdg-open"]}


class AppChooserService(ServiceInterface):
    def __init__(self, defaults):
        super().__init__("org.freedesktop.impl.portal.AppChooser")
        self.defaults = defaults

    @method()
    async def ChooseApplication(
        self,
        handle: "o",
        app_id: "s",
        parent_window: "s",
        choices: "as",
        options: "a{sv}",
    ) -> "ua{sv}":

        uri = options.get("uri").value
        content_type = options.get("content_type").value
        token = options.get("activation_token")
        token = token.value if token else None

        uri = uri.replace('"', "").replace("file://", "")
        content_type = str(content_type)

        activation_token = token or f"token-{os.getpid()}"
        if content_type in self.defaults:
            mapping = self.defaults[content_type]

            if mapping["type"] == "command":
                cmd = mapping["cmd"] + [uri]

            elif mapping["type"] == "desktop":
                entry = find_desktop_entry(mapping["name"])
                cmd = entry["exec"] + [uri]

            else:
                cmd = ["xdg-open", uri]

            print("[TODO]", cmd)

            return self._ok(cmd, activation_token)

        if not choices:
            raise Exception("No application choices provided")

        print(choices)
        entries = [find_desktop_entry(c) for c in choices]
        names = [e["name"] for e in entries]

        if len(entries) == 1:
            cmd = entries[0]["exec"] + [uri]
        else:
            selected = await run_picker(names)
            entry = next(e for e in entries if e["name"] == selected)
            cmd = entry["exec"] + [uri]

        print("[TODO]", cmd)

        return self._ok(cmd, activation_token)

    def _ok(self, cmd, token):
        return [
            0,
            {
                "app_id": Variant("s", str(cmd[0])),
                "activation_token": Variant("s", token),
            },
        ]


async def main():
    bus = await MessageBus().connect()
    await bus.request_name(DBUS_NAME)

    bus.export("/org/freedesktop/portal/desktop", AppChooserService(defaults={}))

    await bus.wait_for_disconnect()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
