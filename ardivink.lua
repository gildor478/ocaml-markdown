oasis = require("oasis")
ci = require("ci")
dist = require("dist")

ci.init()
oasis.init()
dist.init()

ci.prependenv("PATH", "/usr/opt/godi/bin")
ci.prependenv("PATH", "/usr/opt/godi/sbin")
ci.putenv("OUNIT_OUTPUT_HTML_DIR", dist.make_filename("ounit-log-$(suite_name).html"))
ci.putenv("OUNIT_OUTPUT_JUNIT_FILE", dist.make_filename("junit-$(suite_name).xml"))
ci.putenv("OUNIT_OUTPUT_FILE", dist.make_filename("ounit-log-$(suite_name)-$(shard_id).txt"))

oasis.std_process("--enable-tests")

-- TODO:
-- Create documentation package.
-- ci.exec("make", "doc-dev-dist")
