import requests
import csv
from datetime import datetime

url = 'https://api-football-v1.p.rapidapi.com/v3/players/topscorers'

query_params = {
    'league': '39',
    'season': '2020'
}

headers = {
    'X-RapidAPI-Key': 'd7a825d8c8mshb08340a44fcd9c3p18f82bjsn18edf3b47018',
    'X-RapidAPI-Host': 'api-football-v1.p.rapidapi.com'
}

try:
    response = requests.get(url, headers=headers, params=query_params)
    data = response.json()['response']

    if data:
        # Define field names for CSV
        field_names = ['country']

        # Generate a timestamp for the CSV filename
        timestamp = datetime.now().strftime("%Y-%m-%d-%H-%M")
        csv_filename = f'football_players_{timestamp}.csv'

        with open(csv_filename, mode='w', newline='', encoding='utf-8') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=field_names)
            writer.writeheader()

            for player in data:
                # Extract relevant data for each player
                player_data = {
                    'country': player['player']['birth']['country']

                    # Add more fields as needed
                }
                writer.writerow(player_data)

        print(f'Data saved to {csv_filename}')
    else:
        print('No player data found.')

except Exception as e:
    print('Error:', e)
