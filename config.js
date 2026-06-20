/**
 * Supabase Configuration
 *
 * Option A — Local / simple GitHub Pages deploy:
 *   Replace the values below with your Supabase project URL and anon key.
 *
 * Option B — GitHub Actions deploy (recommended):
 *   Add SUPABASE_URL and SUPABASE_ANON_KEY as repository secrets.
 *   The workflow generates this file automatically on deploy.
 *
 * Get credentials from: Supabase Dashboard → Project Settings → API
 */

window.APP_CONFIG = {
  supabaseUrl: 'YOUR_SUPABASE_URL',
  supabaseAnonKey: 'YOUR_SUPABASE_ANON_KEY',
};

window.isAppConfigured = function () {
  return (
    window.APP_CONFIG.supabaseUrl !== 'YOUR_SUPABASE_URL' &&
    window.APP_CONFIG.supabaseAnonKey !== 'YOUR_SUPABASE_ANON_KEY' &&
    window.APP_CONFIG.supabaseUrl.startsWith('https://') &&
    window.APP_CONFIG.supabaseAnonKey.length > 20
  );
};
