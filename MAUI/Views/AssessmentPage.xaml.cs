using System.Diagnostics;
using System.Net.Http.Json;
using wgud424_maui.Models;
using wgud424_maui.Services;

namespace wgud424_maui.Views;

public partial class AssessmentPage : ContentPage
{
    public async void GetData(int id)
    {
        Assessment ca = new Assessment();
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_course/{id}");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
    
                ca = await response.Content.ReadFromJsonAsync<Assessment>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);

                if (ca != new Assessment())
                {
                 StartDate_date.Date = ca.start_date   
                }
            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public AssessmentPage()
	{
		InitializeComponent();
	}
}