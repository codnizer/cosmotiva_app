# Development Guide

## Folder Structure
- `lib/core`: Constants, errors, utils.
- `lib/data`: Repositories implementation, local/remote data sources.
- `lib/domain`: Entities, repository interfaces, usecases.
- `lib/presentation`: Pages, widgets, viewmodels (Riverpod).
- `lib/services`: External services (Gemini, Image Processing).

## Coding Conventions
- Use `Riverpod` for state management.
- Use `Hive` for local persistence.
- Follow `Clean Architecture` principles.
- All entities must have Hive adapters generated.

## Extending Logic
1.  **New Feature**: Add entity in `domain`, repository interface in `domain`, implementation in `data`.
2.  **UI**: Add page in `presentation/pages`, ViewModel in `presentation/viewmodels`.
3.  **Dependency Injection**: Register new providers in `presentation/viewmodels/providers.dart`.

## Generating Code
Run `build_runner` to generate Hive adapters and Mocks:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
