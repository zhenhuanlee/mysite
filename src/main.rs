#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use]
extern crate rocket;
#[macro_use]
extern crate diesel;
extern crate dotenv;
extern crate serde;
#[macro_use]
extern crate serde_derive;
pub mod config;
pub mod controller;
pub mod model;
pub mod schema;

fn main() {
    // model::setting::index();
    controller::launch();
}
