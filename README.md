# stillness. 🌿

> *a personal space to be still.*

stillness is a personal iOS app built as a solo journey — not for the App Store, not for anyone else. just for me. a quiet digital space to reflect, remember, and reset.

---

## why i built this

i needed a change.

not a productivity app. not another tracker with streaks and gamification. something that felt like *mine* — warm, minimal, and honest. a place where i could write to myself, count my dhikr, listen to what's playing, and just... breathe.

this is that place.

---

## features

- 🌙 **home** — greeting, zikir counter, and now playing music card with live album art + progress ring
- 💌 **dear me** — write letters to yourself. attach the song you're listening to. read them back later.
- 🤍 **them** — a separate space. same stillness, different energy.
- ⚙️ **settings** — minimal. just the essentials.

---

## screenshots

> *coming soon — real screenshots from a real phone*

| home | them | dear me |
|------|------|---------|
| ![home](screenshots/home.png) | ![them](screenshots/them.png) | ![dearme](screenshots/dearme.png) |

---

## tech stack

- **swift** + **swiftui** — native iOS 26
- **mediaplayer framework** — live now playing sync with apple music
- **appstorage** + **userdefaults** — local persistence, no backend, no cloud
- **xcode 26** — built and deployed directly to my own phone

---

## running it yourself

this is a personal project — no public release planned. but if you want to build it:

```bash
git clone https://github.com/tenchiift/stillness.git
cd stillness
open stillness.xcodeproj
```

you'll need:
- a mac with xcode 26+
- an apple id for code signing
- an iphone running iOS 26+

---

## the real reason

there's someone i'm trying to forget.

not out of hate — but out of necessity. sometimes the kindest thing you can do for yourself is to slowly, quietly, let go. and i needed a place to do that without anyone watching.

stillness is that place.

every letter i write to myself, every dhikr i count, every song that plays — it's all part of the same thing. learning to be okay on my own again. learning that silence isn't emptiness. learning that *i* am enough to come home to.

this app isn't about moving on fast. it's about moving on *right*.

---

## project structure

tillness/
├── Screens/
│   ├── HomeView.swift
│   ├── ThemView.swift
│   ├── DearMeView.swift
│   └── SettingsView.swift
├── Models/
│   ├── DearMeEntry.swift
│   └── GratitudeLog.swift
└── ContentView.swift


---

## personal note

i'm not a professional developer. i'm just someone who wanted something that didn't exist yet — so i built it. slowly. with a lot of googling, a lot of errors, and a lot of `flutter run` before i switched to swiftui.

this is version 1. it's rough around the edges. and that's okay.

*stillness is a solo journey. this repo is proof i started.*

---

## author

**tenchii** — [@tenchiift](https://github.com/tenchiift)

---

*built with intention. not perfection.* 🌿
