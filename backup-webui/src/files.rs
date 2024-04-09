use axum::extract::Path;
use chrono::NaiveDateTime;
use std::{fs::read_dir, path::PathBuf, str::FromStr};
use tokio::fs::read_to_string;

use askama::Template;

const BACKUP_ROOT: &str = "/backup_data";
const BACKUP_FILENAME: &str = "example.config.xml";
const DIRECTORY_FORMAT: &str = "%Y%m%d-%H%M";

#[derive(Template)]
#[template(path = "list.html")]
pub struct ListTemplate {
    directories: Vec<(String, String)>,
}

pub async fn list() -> ListTemplate {
    let mut directories = vec![];

    if let Ok(entries) = read_dir(BACKUP_ROOT) {
        for entry in entries.filter_map(Result::ok) {
            if let Ok(metadata) = entry.metadata() {
                if metadata.is_dir() {
                    if let Some(path) = entry.path().to_str() {
                        let dir_name = path.split("/").last().unwrap_or_default();
                        if let Ok(datetime) =
                            NaiveDateTime::parse_from_str(dir_name, DIRECTORY_FORMAT)
                        {
                            directories.push((
                                datetime.format("%A, %B %_d - %H:%M").to_string(),
                                dir_name.to_owned(),
                            ));
                        }
                    }
                }
            }
        }
    }
    directories.sort_by(|a, b| b.1.cmp(&a.1));
    ListTemplate { directories }
}

#[derive(Template)]
#[template(path = "contents.html")]
pub struct ContentsTemplate {
    timestamp: String,
    contents: String,
}

pub async fn contents(Path(timestamp): Path<String>) -> ContentsTemplate {
    let dir_name = PathBuf::from_str(BACKUP_ROOT)
        .unwrap()
        .join(&timestamp)
        .join(BACKUP_FILENAME);
    let contents = read_to_string(dir_name)
        .await
        .unwrap_or_default()
        .trim()
        .to_owned();

    ContentsTemplate {
        timestamp: timestamp,
        contents: contents,
    }
}
