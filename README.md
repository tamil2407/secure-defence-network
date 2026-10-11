# 🛡️ Secure Defence Network

### Secure Access. Trusted Connections.

A Flutter-based mobile application that combines Firebase Authentication and biometric verification to provide an additional layer of access control.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile%20App-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-Development-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-Authentication-FFCA28?logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white" alt="Android"/>
</p>

---

## ✨ Key Features

- 🔐 **Firebase Authentication** — Email and password login.
- 👆 **Biometric Verification** — Fingerprint authentication on supported devices.
- 📝 **User Enrollment** — Multi-step registration interface.
- 📱 **Dashboard Access** — Navigation after successful authentication.
- 🎨 **Flutter UI** — A clean, mobile-friendly interface.

## 🔄 Application Workflow

```mermaid
flowchart TD
    A([Launch Application]) --> B[Login Screen]
    B --> C{New User?}
    C -- Yes --> D[User Enrollment]
    D --> B
    C -- No --> E[Firebase Authentication]
    E --> F{Login Successful?}
    F -- No --> B
    F -- Yes --> G[Biometric Verification]
    G --> H{Verification Successful?}
    H -- No --> G
    H -- Yes --> I[Dashboard]
    I --> J([Access Granted])

    style A fill:#142D4E,color:#FFFFFF,stroke:#4DA3FF
    style I fill:#176B52,color:#FFFFFF,stroke:#54D6A0
    style J fill:#176B52,color:#FFFFFF,stroke:#54D6A0
    style F fill:#4A3B75,color:#FFFFFF,stroke:#B6A0FF
    style H fill:#4A3B75,color:#FFFFFF,stroke:#B6A0FF
```

## 🧰 Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Application programming |
| Firebase Authentication | Email/password sign-in |
| Firebase Core | Firebase integration |
| `local_auth` | Device biometric verification |
| Android SDK | Android application platform |

## 📸 Project Overview

The application follows a two-stage access flow:

1. **Identity Verification:** Users sign in using their registered email and password.
2. **Biometric Verification:** Users complete a device-supported biometric check before accessing the dashboard.

## 🚀 Future Enhancements

- Dedicated backend server integration.
- Role-based access control.
- Complete user registration and profile management.
- Secure communication features.
- Enhanced security testing and data protection.

## 🔒 Security Notice

This project is a development prototype. Firebase Authentication and biometric verification provide access-control features but do not guarantee complete application or communication security. It is not intended for classified or sensitive operational use.

---

<p align="center">
  <b>🛡️ Secure Defence Network</b><br>
  Built with Flutter • Focused on Secure Access
</p>
