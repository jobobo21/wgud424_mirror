using System.Xml;
using wgud424_maui.Services;
using wgud424_maui.Views;
using System.Net.Http.Json;
using wgud424_maui.Models;
using System.Diagnostics;

namespace wgud424_maui
{
    public partial class AppShell : Shell
    {

        public void AddTerm(Term tempTerm)
        {
            Debug.WriteLine("Term Found");
            TermView tf = new TermView(tempTerm, this);
            ShellContent sc = new ShellContent();
            sc.Title = "Test";
            sc.Route = $"Term-{tempTerm.id}";
            sc.ContentTemplate = new DataTemplate(() => tf);
            Terms.Items.Add(tf);

        }
        public async void PopulateTerms()
        {
            HttpResponseMessage hrm = await DatabaseHandler.Get("/terms");
            if (hrm != null)
            {
                if (hrm.IsSuccessStatusCode)
                {
                    // Request was successful (e.g., 200 OK, 201 Created)
                    // Optionally, read the response content if the API returns data
                    var result = await hrm.Content.ReadFromJsonAsync<List<Term>>();
                    string jsonString = await hrm.Content.ReadAsStringAsync();

                    if (result != null)
                    {
                        foreach (Term t in result)
                        {
                            AddTerm(t);
                        }
                    }
                }
                else
                {
                    // Request failed, handle the error
                    Debug.WriteLine($"Error: {hrm.StatusCode} - {await hrm.Content.ReadAsStringAsync()}");
                }
            }
        }
        public AppShell()
        {
            InitializeComponent();
            MainPage mp = new MainPage(this);
            ShellContent sc = new ShellContent();
            sc.Title = "Test";
            sc.Route = $"MainPage";
            sc.ContentTemplate = new DataTemplate(() => mp);
            Terms.Items.Add(mp);
        }
    }
}
