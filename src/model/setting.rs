use super::config::{db};
use rocket_contrib::json::Json;
use diesel::prelude::*;
use std::time::SystemTime;

#[derive(Debug, Queryable, Serialize)]
pub struct Setting {
    pub id: i32,
    pub head: String,
    pub body: String,
    pub inuse: bool,
    pub created_at: SystemTime,
    pub updated_at: SystemTime,
}

pub fn index() -> Json<Vec<Setting>> {
    use super::schema::settings::dsl::*;

    let connection = db::connect();
    let results = settings.filter(inuse.eq(true))
        .limit(5)
        .load::<Setting>(&connection)
        .expect("Error loading posts");

    Json(results)
    // println!("Displaying {} posts", results.len());
    // for post in results {
    //     println!("{} - {}", post.head, post.body);
    // }
}