using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Http;
using System.Net.Http.Json;
using System.Diagnostics; // Required for PostAsJsonAsync
namespace wgud424_maui.Services
{

    internal class DatabaseHandler
    {

        private static HttpRequestMessage message;
        private static HttpClient client { get; set; }
       
        async static Task<HttpClient> init(string path)
        {
            string token = await SecureStorage.Default.GetAsync("JWT");
            client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", token);
            return client;

        }
        async public static Task<HttpResponseMessage> Get(string path)
        {
            try
            {
                client = await init(path);

                message = new HttpRequestMessage(HttpMethod.Get, $"https://king-prawn-app-y5xwb.ondigitalocean.app{path}");

                HttpResponseMessage response = await client.SendAsync(message);
                return response;
            }
            catch (Exception ex) {
                Debug.WriteLine("Exception", ex.Message);
                return new HttpResponseMessage();
            }
           

        }
    }
}
