// deep end sync config. leave both blank for local-only mode (the app still fully works).
// when the supabase project exists, fill these two values and redeploy. the anon key is
// designed to be public; row level security protects everyone's data.
window.DEEP_END_CONFIG = {
  SUPABASE_URL: "",
  SUPABASE_ANON_KEY: ""
};
