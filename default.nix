{ stdenv, fetchgit, cmake, boost, gmp, mpfr, libedit, python
, texinfo, gnused }:

let
  version = "3.1.1";
  rev = "20161114";
in

stdenv.mkDerivation {
  name = "ledger-${version}-${rev}";

  # NOTE: fetchgit because ledger has submodules not included in the
  # default github tarball.
  src = ./.;

  buildInputs = [ cmake boost gmp mpfr libedit python texinfo gnused ];

  enableParallelBuilding = true;

  # Skip byte-compiling of emacs-lisp files because this is currently
  # broken in ledger...
  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp -v "$src/lisp/"*.el $out/share/emacs/site-lisp/
  '';

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = {
    homepage = "http://ledger-cli.org/";
    description = "A double-entry accounting system with a command-line reporting interface";
    license = stdenv.lib.licenses.bsd3;

    longDescription = ''
      Ledger is a powerful, double-entry accounting system that is accessed
      from the UNIX command-line. This may put off some users, as there is
      no flashy UI, but for those who want unparalleled reporting access to
      their data, there really is no alternative.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ the-kenny jwiegley ];
  };
}
