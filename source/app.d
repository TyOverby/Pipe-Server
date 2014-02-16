import vibe.d;

void handleRequest(HTTPServerRequest req,
                   HTTPServerResponse res) {
    res.writeBody("Hello, World!", "text/plain");
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
