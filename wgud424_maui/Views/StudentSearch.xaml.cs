using System.Net.Http.Json;
using wgud424_maui.Services;
using System.Diagnostics;
namespace wgud424_maui.Views;

public class StudentSearchResult
{
    int id {  get; set; }
	public string first_name { get; set; } = string.Empty;
	public string last_name { get; set; } = string.Empty;
    public string full_name {  get; set; } = string.Empty;

	public string email { get; set; } = string.Empty;
	public MiniProgram program { get; set; } = new MiniProgram();
}
public class MiniProgram
{
	public string name {  get; set; } = string.Empty;
	public string code { get; set; } = string.Empty;
	public string degree_level {  get; set; } = string.Empty;
}
public partial class StudentSearch : ContentPage
{
    public List<StudentSearchResult> results = new List<StudentSearchResult>();


    public async void GetData()
    {
        string path = "/user/students";
        if (StudentSearch_entry.Text != null && StudentSearch_entry.Text.Length > 0)
        {
            path += $"?searchString={StudentSearch_entry.Text}";
        }

        HttpResponseMessage response = await DatabaseHandler.Get(path);
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.Write($"\n\n\n\n {jsonString}  \n\n\n\n\n");
                results = await response.Content.ReadFromJsonAsync<List<StudentSearchResult>>();
                StudentSearch_CollectionView.ItemsSource = results;
            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public StudentSearch()
	{
		InitializeComponent();
        GetData();
	}

    private void Search_btn_Clicked(object sender, EventArgs e)
    {
        GetData();

    }

    private void Back_btn_Clicked(object sender, EventArgs e)
    {
        Navigation.PopModalAsync();
    }
}