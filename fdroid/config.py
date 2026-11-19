import os

owner = os.environ["REPO_OWNER"]
name = os.environ["REPO_NAME"]

repo_name = "Twelve Standalone"
repo_url = "https://{owner}.github.io/{name}".format(owner=owner, name=name)
repo_description = (
    "Unofficial, automatically rebuilt APKs of the LineageOS Twelve music "
    "player (org.lineageos.twelve), synced continuously from the upstream "
    "LineageOS repository and packaged for any Android 11+ device."
)

repo_maxage = 1440

keystore = os.environ.get("KEYSTORE_PATH", os.path.abspath("keystore.jks"))
keystorepass = os.environ.get("FDROID_KEYSTORE_PASSWORD", "twelve-standalone")
keyalias = os.environ.get("FDROID_KEY_ALIAS", "twelve")
keypass = os.environ.get("FDROID_KEY_PASSWORD", keystorepass)
