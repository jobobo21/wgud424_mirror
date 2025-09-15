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
        public List<Term> _Terms = new List<Term>();
        MainPage mp { get; set; }
        AddTermForm addTermForm { get; set; }
        public void AddTerm(Term tempTerm)
        {
            Debug.WriteLine("Term Found");
            TermView tf = new TermView(tempTerm, this);
            ShellContent sc = new ShellContent();
            sc.Title = "Term " + tempTerm.term_no;
            sc.Route = $"Term-{tempTerm.id}";
            sc.ContentTemplate = new DataTemplate(() => tf);
            Terms.Items.Add(tf);

        }
        private void AddMainPageTab()
        {
            ShellContent sc = new ShellContent();
            sc.Title = "Status";
            sc.Route = $"MainPage";
            sc.ContentTemplate = new DataTemplate(() => mp);

            Terms.Items.Add(mp);
        }
        private void AddAddTermForm()
        {
            ShellContent sc = new ShellContent();
            sc.Title = "Add Term";
            sc.Route = "AddTermForm";
            sc.ContentTemplate = new DataTemplate(() => addTermForm);
            Tab t = new Tab { Title = "Add Term", Items = { sc } };
            Terms.Items.Add(t);
        }
     
        public async void PopulateTerms()
        {
            Terms.Items.Clear();
            AddMainPageTab();
            HttpResponseMessage hrm = await DatabaseHandler.Get("/terms");
            if (hrm != null)
            {
                if (hrm.IsSuccessStatusCode)
                {
                    // Request was successful (e.g., 200 OK, 201 Created)
                    // Optionally, read the response content if the API returns data
                    var result = await hrm.Content.ReadFromJsonAsync<List<Term>>();
                    string jsonString = await hrm.Content.ReadAsStringAsync();
                    Debug.WriteLine(jsonString);
                    if (result != null)
                    {
                        _Terms = result;
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
            AddAddTermForm();
        }
        public AppShell()
        {
           InitializeComponent();
            mp = new MainPage(this);
            addTermForm = new AddTermForm(this);
           AddMainPageTab();
        }
    }
}
