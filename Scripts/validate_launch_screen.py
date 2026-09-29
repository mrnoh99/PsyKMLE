#!/usr/bin/env python3
"""런치스크린에 적힌 버전 표기가 프로젝트 설정과 일치하는지 검사한다.

런치스크린은 앱 코드가 실행되기 전에 시스템이 그리므로 번들에서 버전을
읽어올 수 없고, 글자를 직접 적어두는 수밖에 없다. 그래서 빌드 번호를
올릴 때 이 글자를 같이 고치지 않으면 옛 번호가 그대로 남는다.
(실제로 Build 8이 한동안 남아 있었다.)

사용법: python3 Scripts/validate_launch_screen.py
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
PROJECT_FILE = REPO_ROOT / "PsyKMLE.xcodeproj" / "project.pbxproj"
LAUNCH_SCREEN = REPO_ROOT / "PsyKMLE" / "LaunchScreen.storyboard"

LABEL_ID = "version-label"


def unique_setting(text: str, key: str) -> str | None:
    """빌드 설정 값을 읽는다. 구성마다 값이 다르면 None."""
    values = set(re.findall(rf"^\s*{key} = ([^;]+);", text, re.M))
    if len(values) != 1:
        return None
    return values.pop().strip().strip('"')


def main() -> int:
    project = PROJECT_FILE.read_text(encoding="utf-8")
    storyboard = LAUNCH_SCREEN.read_text(encoding="utf-8")
    errors: list[str] = []

    version = unique_setting(project, "MARKETING_VERSION")
    build = unique_setting(project, "CURRENT_PROJECT_VERSION")

    if version is None:
        errors.append("MARKETING_VERSION이 빌드 구성마다 다르거나 찾을 수 없다")
    if build is None:
        errors.append("CURRENT_PROJECT_VERSION이 빌드 구성마다 다르거나 찾을 수 없다")

    label = re.search(rf'<label[^>]*text="([^"]*)"[^>]*id="{LABEL_ID}"', storyboard)
    if label is None:
        label = re.search(rf'<label[^>]*id="{LABEL_ID}"[^>]*text="([^"]*)"', storyboard)

    if label is None:
        errors.append(
            f'{LAUNCH_SCREEN.relative_to(REPO_ROOT)}: id="{LABEL_ID}" 라벨을 찾지 못했다. '
            "라벨을 지웠다면 이 검사도 함께 정리해야 한다"
        )
    elif version and build:
        expected = f"Version {version} (Build {build})"
        actual = label.group(1)
        if actual != expected:
            errors.append(
                f"{LAUNCH_SCREEN.relative_to(REPO_ROOT)}: 런치스크린 버전 표기가 프로젝트 설정과 다르다\n"
                f"      런치스크린: {actual!r}\n"
                f"      프로젝트  : {expected!r}\n"
                f"      → 런치스크린 라벨을 {expected!r}로 고치거나, 빌드 번호를 되돌려라"
            )

    if errors:
        print("런치스크린 검사 실패:", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        return 1

    print(f"런치스크린 버전 표기 일치: Version {version} (Build {build})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
