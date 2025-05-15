# app

### build instructions

add a `.env.json` file in the root directory with the fllowing content

```json
{
    "SUPABASE_URL": "url",
    "SUPABASE_KEY": "the anon key from the supabase instance"
}
```

```bash
flutter run --dart-define-from-file=.env.json
```

