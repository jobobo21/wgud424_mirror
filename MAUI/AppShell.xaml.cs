using MAUI.Views;

namespace MAUI
{
    public partial class AppShell : Shell
    {
        private async void ShowLogin()
        {
            await Navigation.PushModalAsync(new LoginPage());
        }
        public AppShell()
        {
            InitializeComponent();
            ShowLogin();
           
        }
    }
}
