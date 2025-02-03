# -- api request for BTC and ETH cryptocurrencies -- 

import requests
import csv

API_KEY = 'A6I5R4BAUKN0Z9CU'
function = 'DIGITAL_CURRENCY_DAILY'
symbol = input("Please write the ticker symbol of the cryptocurrency: ")
market = 'USD'

def get_crypto_raw(API_KEY, function, symbol, market):

    url = f'https://www.alphavantage.co/query?function={function}&symbol={symbol}&market={market}&apikey={API_KEY}&datatype=csv'
    response = requests.get(url)
    raw_data = response.text
    data = list(csv.reader(raw_data.splitlines()))

    return data

def write_crypto_data(data, symbol):
    doc = open(f"prices.{symbol}.csv", 'w')
    # for loop will be used to write (full outputsize) the date (index position [i][0])
    for i in range (len(data)):
        line_data = data[i][:5] + data[i][9:11]
        separator = ', '
        doc.write(separator.join(line_data) + '\n')
        # doc.write(f"{str(data[i][0:5])} {str(data[i][9:11])}\n")
    doc.close()
    # program output (not doc.write) for the stock symbol written through command line (argv)
    print(f"Wrote historical price data for {symbol} to file price.{symbol}.txt")

data = get_crypto_raw(API_KEY, function, symbol, market)
write_crypto_data(data, symbol)


