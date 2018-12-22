#[macro_use]
extern crate diesel;
extern crate dotenv;

pub mod config;
pub mod controller;
pub mod model;
pub mod schema;

fn main() {
    model::setting::Setting::index();
}
