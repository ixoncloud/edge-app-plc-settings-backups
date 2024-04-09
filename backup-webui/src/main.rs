use axum::{routing::get, Router};
use tower_http::services::ServeDir;

mod files;

#[tokio::main]
async fn main() {
    let routes = Router::new()
        .route("/", get(files::list))
        .route("/:timestamp", get(files::contents))
        .nest_service("/static", ServeDir::new("/app/static"));

    let listener = tokio::net::TcpListener::bind("0.0.0.0:8080").await.unwrap();
    axum::serve(listener, routes).await.unwrap();
}
