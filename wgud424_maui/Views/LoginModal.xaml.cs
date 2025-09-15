


using System;
using System.Diagnostics;
using System.Net.Http;
using System.Text;
using CommunityToolkit.Maui.Alerts;
using CommunityToolkit.Maui.Core;
using wgud424_maui.Services;

namespace wgud424_maui.Views;
public partial class LoginModal : ContentPage
{
    private readonly MainPage _parent;
    private readonly ILoginService _loginService;
    string text = "Login Failure Please try again";
    ToastDuration duration = ToastDuration.Short;
    
    double fontSize = 14;
    public string EmailText
    {
        get => Emailentry.Text;
        set => Emailentry.Text = value;
    }

    public string PasswordText
    {
        get => PasswordEntry.Text;
        set => PasswordEntry.Text = value;
    }
    public LoginModal(MainPage parg, ILoginService loginService)
	{
        _parent = parg;
        _loginService = loginService;
        InitializeComponent();
	}
    public async Task<bool> HandleLogin()
    {
        try
        {
            Toast.Make("Login Success!", duration, 14);
            return await _loginService.LoginAsync(EmailText, PasswordText);

        }
        catch(Exception e)
        {
            Debug.WriteLine("Error Logging In");
            Toast.Make($"Login Failure!\n{e.Message}", duration, 14);

            Debug.WriteLine(e.Message);
            return false;
        }

 
    }
    public async void LoginBtn_Clicked(object sender, EventArgs e)
    {
        bool loginResult = await HandleLogin();
        Debug.WriteLine($"\n\n\nLogin Btn Clicked\n\n\n");
        Debug.WriteLine($"\n\n\nLogin Result {loginResult}\n\n\n");


        if (loginResult)
        {
            _parent?.GetData();
            Navigation?.PopModalAsync();

        }
        else
        {
            var toast = Toast.Make("Login Failure Incorrect Credentials!", ToastDuration.Short, 14);
            toast.Show();
        }


    }
}