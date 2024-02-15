{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, aiohttp
, python-dateutil
, typing-extensions
}:

buildPythonPackage rec {
  pname = "twitchapi";
  version = "4.2.0";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teekeks";
    repo = "pyTwitchAPI";
    rev = "refs/tags/v${version}";
    hash = "sha256-QAxLYujnsudaiz9UepwrBA835Pct5h4VcE9ZrbkwMmg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
    typing-extensions
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "twitchAPI.eventsub"
    "twitchAPI.oauth"
    "twitchAPI.pubsub"
    "twitchAPI.twitch"
    "twitchAPI.type"
  ];

  meta = with lib; {
    changelog = "https://github.com/Teekeks/pyTwitchAPI/blob/${src.rev}/docs/changelog.rst";
    description = "Python implementation of the Twitch Helix API, its Webhook, PubSub and EventSub";
    homepage = "https://github.com/Teekeks/pyTwitchAPI";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda wolfangaukang ];
  };
}
