import vibe.d;
import std.file: read, write;
import std.string;
import std.base64;
import std.stdio;
import std.process;
import std.algorithm;

uint fileNum;

void handleRequest(HTTPServerRequest req,
                   HTTPServerResponse res) {
/++    writeln(req.params);
    writeln(req.query);
    writeln(req.queryString);
    writeln(req.form); ++/
    string source = req.query["source"];

    ubyte[] decoded = Base64.decode(source);

    auto curr = fileNum++;

    write("%d.pipe".format(curr), decoded);

    auto pid = spawnShell("./comp.sh %d.pipe".format(curr));
    wait(pid);


    //res.writeBody(buff, "text/plain");
    res.writeBody(cast(ubyte[]) read("%d.pipe.pdf".format(curr)), "application/pdf");
    //res.writeBody(cast(ubyte[]) read("untitled.pdf"), "application/pdf");
}

shared static this()
{
    auto settings = new HTTPServerSettings;
    settings.port = 8080;

    auto fsettings = new HTTPFileServerSettings;
    fsettings.serverPathPrefix = "/static";

    auto router = new URLRouter;
    router.get("/static/*", serveStaticFiles("public/", fsettings));
    router.get("/compile", &handleRequest);

    listenHTTP(settings, router);
}
