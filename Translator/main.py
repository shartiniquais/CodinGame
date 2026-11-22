from parser_python import PythonToCentralParser
from emitters.emit_c import CEmitter

SOURCE_FILE = "onboarding.py"


def main():
    parser = PythonToCentralParser()
    program = parser.parse_file(SOURCE_FILE)

    emitter = CEmitter()
    c_code = emitter.emit_program(program)

    print(c_code)


if __name__ == "__main__":
    main()