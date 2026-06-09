import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
DEFAULT_PATH = ROOT / "tests" / "funcional" / "api"


def run_robot(path, tags=None):
    cmd = ["robot"]
    if tags:
        cmd.extend(["--include", tags])
    cmd.append(str(path))
    return subprocess.run(cmd, cwd=ROOT).returncode


def main():
    parser = argparse.ArgumentParser(description="Executa os testes API Restful-Booker")
    parser.add_argument("--suite", choices=["auth", "booking", "performance", "security", "smoke", "all"], default="all",
                        help="Suite de testes para executar")
    args = parser.parse_args()

    if args.suite == "all":
        path = DEFAULT_PATH
    else:
        path = DEFAULT_PATH / args.suite

    rc = run_robot(path)
    sys.exit(rc)


if __name__ == "__main__":
    main()
