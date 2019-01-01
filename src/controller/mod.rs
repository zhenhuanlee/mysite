mod setting;

use rocket::response::content::Html;

pub fn launch() {
    rocket::ignite()
        .mount("/", routes![root])
        .mount("/hello", routes![hello])
        .mount("/settings", routes![setting::index])
        .launch();
}

#[get("/")]
fn root() -> Html<&'static str> {
    Html(r"<h1>hi</h1>")
}

#[get("/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}