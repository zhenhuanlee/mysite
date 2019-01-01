use super::super::model::setting;
use rocket_contrib::json::Json;

#[get("/index")]
pub fn index() -> Json<Vec<setting::Setting>> {
    setting::index()
}