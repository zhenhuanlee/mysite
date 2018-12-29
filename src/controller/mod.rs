pub fn launch() {
    rocket::ignite()
        .mount("/", routes![root])
        .mount("/hello", routes![hello])
        .launch();
}

#[get("/")]
fn root() {
    format!("hi");
}

#[get("/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}