table! {
    settings (id) {
        id -> Int4,
        head -> Varchar,
        body -> Text,
        inuse -> Bool,
        created_at -> Timestamp,
        updated_at -> Timestamp,
    }
}