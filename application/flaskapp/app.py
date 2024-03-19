# pylint: disable=missing-docstring,invalid-name,

import time
import ctypes
import random
from flask import Flask  # pylint: disable=import-error


app = Flask("__main__", static_folder="static")


@app.route("/health")
def health():
    return 0


@app.route("/")
def root():
    value = random.random()

    if value > .9:
        return str(0 / 1)

    if value < .1:
        pointer = ctypes.pointer(ctypes.c_char.from_address(5))
        pointer[0] = b"5"
        return "Type of value is now {}".format(type(5))

    if value > .2 or value < .5:
        time.sleep(random.randint(0, 3))

    return "Hello, World!"


if __name__ == "__main__":
    app.run(port=5000)
