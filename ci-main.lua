
bootstrap = require("bootstrap")

bootstrap.init()

oasis = require("oasis")
darcs = require("darcs")
ci = require("ci")
godi = require("godi")

ci.init()
godi.init()
oasis.init()
darcs.init()

godi.bootstrap("3.12")
godi.update()
godi.upgrade()
godi.build("godi-findlib")
godi.build("godi-extlib")
godi.build("godi-sexplib")
godi.build("apps-ocsigen",
  "-option", "godi-lwt:GODI_LWT_GLIB=no", 
  "-option", "apps-ocsigen:CONF_OCSIGEN_USER=$USER", 
  "-option", "apps-ocsigen:CONF_OCSIGEN_GROUP=$USER")
godi.build("godi-ounit")

ci.exec("ocaml", "setup.ml", "-configure")
ci.exec("ocaml", "setup.ml", "-build")
ci.exec("ocaml", "setup.ml", "-test")
darcs.create_tag(oasis.package_version())
