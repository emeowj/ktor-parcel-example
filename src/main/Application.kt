package com.paobble.demo

import io.ktor.application.*
import io.ktor.response.*
import io.ktor.request.*
import io.ktor.routing.*
import io.ktor.http.*
import com.github.mustachejava.DefaultMustacheFactory
import io.ktor.mustache.Mustache
import io.ktor.mustache.MustacheContent
import io.ktor.content.*
import io.ktor.features.*
import io.ktor.http.content.*

fun main(args: Array<String>): Unit = io.ktor.server.netty.EngineMain.main(args)

@Suppress("unused") // Referenced in application.conf
@kotlin.jvm.JvmOverloads
fun Application.module(testing: Boolean = false) {
    install(Mustache) {
        mustacheFactory = DefaultMustacheFactory("build")
    }

    install(CallLogging) {}
    install(StatusPages) {
        status(HttpStatusCode.NotFound) {
            call.respond(MustacheContent("404.hbs.html", mapOf("uri" to call.request.uri)))
        }
    }

    routing {
        get("/") {
            call.respond(
                MustacheContent("index.hbs.html", mapOf("message" to "Hello ktor!")))
        }

        // Static feature. Try to access `/static/ktor_logo.svg`
        static("/static") {
            resources("static")
            resources("build")
        }
    }
}