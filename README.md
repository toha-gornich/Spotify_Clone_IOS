# 🎵 Spotify Clone iOS

> A mobile client for an audio streaming service, inspired by Spotify.  
> The app communicates with a custom REST API to manage music content, playlists, and user authentication.

---

## 🚀 Features

- **iOS Client** — built with Swift using UIKit / SwiftUI.
- **Backend Integration** — full integration with the [Spotify Clone API](https://github.com/MafanNam/Spotify_Clone_API).
- **Auth** — user registration and login via JWT.
- **Music Player** — real-time track playback.
- **Library** — manage albums, artists, and personal playlists.
- **Search** — find music by title or artist.

---

## 🛠 Tech Stack

| Layer | Tools |
|---|---|
| Language / UI | Swift 5, UIKit / SwiftUI |
| Networking | URLSession / Alamofire |
| Image Loading | Kingfisher / SDWebImage |
| Audio | AVFoundation |
| Min. Version | iOS 15.0+ |

---

## ⚙️ Setup & Run

### 1. Backend (API)

Before running the iOS app, make sure the backend is up and running.  
You can use a local instance or the deployed version:

🔗 **API Repository:** [MafanNam/Spotify_Clone_API](https://github.com/MafanNam/Spotify_Clone_API)

### 2. Clone the Repository

```bash
git clone https://github.com/toha-gornich/Spotify_Clone_IOS.git
cd Spotify_Clone_IOS
```

### 3. Configure the API URL

Find the configuration file (`Constants.swift` or `NetworkManager.swift`) and update `baseURL` with your address:

```swift
// Example:
let baseURL = "https://spotify-api-production-6731.up.railway.app"
```

### 4. Run in Xcode

1. Open the `.xcodeproj` or `.xcworkspace` file.
2. Select a simulator (e.g., iPhone 14 / 15).
3. Press **Cmd + R** to build and run.

---

## 📸 Screenshots

| Home | Player | Library |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Player](screenshots/player.png) | ![Library](screenshots/library.png) |

> 📌 *Add your screenshots to the `screenshots/` folder in the project root.*

---

## 👨‍💻 Author

**Anton Gornich** — [GitHub Profile](https://github.com/toha-gornich)

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
