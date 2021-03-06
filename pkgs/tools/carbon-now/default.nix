# Other files generated by:
# > nix run nixpkgs.nodePackages_13_x.node2nix -c node2nix -c package.nix -13 -d -l
#
# Note that it currently depends on some of its dev dependencies at runtime,
# such as 'execa', so we must use '-d'

{ pkgs # pkgs is imported directly for compatibility with node2nix
, nodejs
}:

let
  version = "1.4.0";

  results = import ./package.nix { inherit pkgs nodejs; };
  carbon-now = results.package.override (old: {
    name = "carbon-now-1.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "mixn";
      repo = "carbon-now-cli";
      rev = "v${version}";
      sha256 = "0qxhz3ddbvrixbqmv1xcq4chbrlx1r027crcpwcry4ric99b4vra";
    };

    # puppeteer tries to download chromium during install, so this needs to be set
    # to anything in order to skip it
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "y";

    # provide a chromium from nixpkgs instead
    buildInputs = (old.buildInputs or []) ++ [ pkgs.makeWrapper ];
    postInstall = (old.postInstall or "") + ''
      wrapProgram "$out/bin/carbon-now" \
        --set PUPPETEER_EXECUTABLE_PATH "${pkgs.chromium}/bin/chromium"
    '';

    meta = with pkgs.lib; {
      description = "Beautiful images of your code-from right inside your terminal.";
      homepage = "https://github.com/mixn/carbon-now-cli";
      platforms = platforms.unix;
      license = licenses.mit;
    };
  });
in carbon-now.overrideAttrs (_: {
  name = "carbon-now-${version}";
})
