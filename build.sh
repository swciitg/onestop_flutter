#!/bin/bash

set -e

# ── Environment ──────────────────────────────────────────────────────────────
echo ""
echo "Select environment:"
echo "  1) dev"
echo "  2) prod"
echo "  0) exit"
echo ""
read -rp "Choice [1]: " ENV_CHOICE
ENV_CHOICE="${ENV_CHOICE:-1}"

case "$ENV_CHOICE" in
  1) FLAVOR="dev"; ENV_FILE=".env.dev" ;;
  2) FLAVOR="prod"; ENV_FILE=".env.prod" ;;
  0) echo "Exiting."; exit 0 ;;
  *) echo "Invalid choice: $ENV_CHOICE."; exit 1 ;;
esac

# ── Build type ───────────────────────────────────────────────────────────────
echo ""
echo "Select build type:"
echo "  1) appbundle (Android - Play Store)"
echo "  2) apk (Android - direct install)"
echo "  3) ipa (iOS)"
echo "  0) exit"
echo ""
read -rp "Choice [1]: " BUILD_CHOICE
BUILD_CHOICE="${BUILD_CHOICE:-1}"

case "$BUILD_CHOICE" in
  1) BUILD_TYPE="appbundle" ;;
  2) BUILD_TYPE="apk" ;;
  3) BUILD_TYPE="ipa" ;;
  0) echo "Exiting."; exit 0 ;;
  *) echo "Invalid choice: $BUILD_CHOICE."; exit 1 ;;
esac

# ── Load env file ─────────────────────────────────────────────────────────────
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: $ENV_FILE not found."
  exit 1
fi

# ── Build dart-define args ────────────────────────────────────────────────────
DART_DEFINE_ARGS=()
while IFS= read -r line || [[ -n "$line" ]]; do
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// }" ]] && continue
  key="${line%%=*}"
  value="${line#*=}"
  DART_DEFINE_ARGS+=("--dart-define" "${key}=${value}")
done < "$ENV_FILE"

# ── Preview command ───────────────────────────────────────────────────────────
if [[ "$BUILD_TYPE" == "ipa" ]]; then
  FINAL_CMD="flutter build ipa --no-tree-shake-icons ${DART_DEFINE_ARGS[*]}"
else
  FINAL_CMD="flutter build $BUILD_TYPE --no-tree-shake-icons --flavor $FLAVOR ${DART_DEFINE_ARGS[*]}"
fi

echo ""
echo "Command to run:"
echo ""
echo "  $FINAL_CMD"
echo ""
read -rp "Proceed? (y/n) [y]: " CONFIRM
CONFIRM="${CONFIRM:-y}"
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted."
  exit 0
fi

# ── Run build ─────────────────────────────────────────────────────────────────
echo ""
echo "Building $BUILD_TYPE [$FLAVOR] ..."
echo ""

if [[ "$BUILD_TYPE" == "ipa" ]]; then
  flutter build ipa \
    --no-tree-shake-icons \
    "${DART_DEFINE_ARGS[@]}" || true

  ARCHIVE_PATH="build/ios/archive/Runner.xcarchive"
  if [[ -d "$ARCHIVE_PATH" ]]; then
    echo ""
    read -rp "Open archive in Xcode to upload? (y/n) [y]: " OPEN_XCODE
    OPEN_XCODE="${OPEN_XCODE:-y}"
    if [[ "$OPEN_XCODE" == "y" || "$OPEN_XCODE" == "Y" ]]; then
      open "$ARCHIVE_PATH"
    fi
  fi
else
  flutter build "$BUILD_TYPE" \
    --no-tree-shake-icons \
    --flavor "$FLAVOR" \
    "${DART_DEFINE_ARGS[@]}"
fi

echo ""
echo "Build complete."
