using System.Diagnostics;
using System.Net.Http.Json;
using wgud424_maui.Models;
using wgud424_maui.Services;

namespace wgud424_maui.Views;

public partial class AssessmentPage : ContentPage
{
    public async void GetData(int id)
    {
        StudentAssessment ca = new StudentAssessment();
        HttpResponseMessage response = await DatabaseHandler.Get($"/student_assessment/{id}");
        if (response != null)
        {
            if (response.IsSuccessStatusCode)
            {
    
                ca = await response.Content.ReadFromJsonAsync<StudentAssessment>();
                string jsonString = await response.Content.ReadAsStringAsync();
                Debug.WriteLine(jsonString);

            }
            else
            {
                // Request failed, handle the error
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }
        }
    }
    public AssessmentPage(int assessmentId)
	{
		InitializeComponent();
        GetData(assessmentId);
	}
}