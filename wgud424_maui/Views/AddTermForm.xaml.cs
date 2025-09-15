using System.Net.Http.Json;
using CommunityToolkit.Maui.Core;
using wgud424_maui.Models;
using CommunityToolkit.Maui.Alerts;

using wgud424_maui.Services;
using Microsoft.Maui.Graphics;
using System.Diagnostics;
namespace wgud424_maui.Views;

public partial class AddTermForm : ContentPage
{
	private AppShell _parent;
	private Term _term = new Term();

    public AddTermForm(AppShell parent)
	{
		InitializeComponent();
		_parent = parent;
		
    }
    protected override void OnAppearing()
    {
        base.OnAppearing();
        ContentPage.Title = $"Add Term {_parent._Terms.Count + 1}";
        if (_parent._Terms.Count > 0)
        {
            
            StartDatePicker.Date = _parent._Terms.First().endDate.AddDays(1);
            EndDatePicker.Date = StartDatePicker.Date.AddMonths(6).AddDays(-1);
        }
        else
        {
            StartDatePicker.Date = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
            StartDatePicker.Date = StartDatePicker.Date.AddMonths(1);
            EndDatePicker.Date = StartDatePicker.Date.AddMonths(6).AddDays(-1);
        }
    }
    private void Toaster(string message)
    {
        var toast = Toast.Make(message, ToastDuration.Short, 14);
        toast.Show();
    }
    private async void CreateTerm()
	{
        _term.term_no = _parent._Terms.Count + 1;
        _term.startDate = StartDatePicker.Date;
        _term.endDate = EndDatePicker.Date;
        DateTime tmptime = _term.startDate.AddMonths(5);
        if (_term.startDate >= _term.endDate)
        {
            Toaster("Start Date must be before End Date");
            return;
        }
        else if (_term.endDate < tmptime)
        {
            Toaster("Terms must be 6 months in length");
            return;
        }
       

        JsonContent json = JsonContent.Create<Term>(_term);
        string path = "/terms";
        HttpResponseMessage hrm = await DatabaseHandler.Post(path, json);
        if (hrm != null && hrm.IsSuccessStatusCode)
        {
            Debug.WriteLine("\n\n\n\n Creation Success \n\n\n\n\n");
            _parent.PopulateTerms();
            _parent.GoToAsync("//MainPage");
            Toaster("Term Created Successfully");

        }
        else
        {
            Debug.WriteLine("\n\n\n\n Creation Failure \n\n\n\n\n");

        }

    }
    private void CreateTerm_btn_Clicked(object sender, EventArgs e)
    {
        CreateTerm();
    }
}