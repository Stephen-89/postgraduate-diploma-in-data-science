from flask import Flask, jsonify, render_template
from pathlib import Path
import csv
import statistics
import matplotlib.pyplot as plt

app = Flask(__name__)

class CveVulnerabilities:
    def __init__(self, cve_id, link, vendor, product, description, year, published_date, vector_string, base_score, impact_score, exploitability_score):
        self.cve_id = cve_id
        self.link = link
        self.vendor = vendor
        self.product = product
        self.description = description
        self.year = year
        self.published_date = published_date
        self.vector_string = vector_string
        self.base_score = base_score
        self.impact_score = impact_score
        self.exploitability_score = exploitability_score

    def to_dict(self):
        return {
            'cve_id': self.cve_id,
            'link': self.link,
            'vendor': self.vendor,
            'product': self.product,
            'description': self.description,
            'year': self.year,
            'published_date': self.published_date,
            'vector_string': self.vector_string,
            'base_score': self.base_score,
            'impact_score': self.impact_score,
            'exploitability_score': self.exploitability_score
        }

def all_vulnerabilities(file_path):
    
    vulnerabilities = []

    with open(file_path, 'r', newline='', encoding='utf-8') as file:
        
        reader = csv.DictReader(file)
        
        for row in reader:
            try:
                
                cve_id = int(row.get('cve_id', ''))
                link = row.get('link', '')
                vendor = row.get('vendor', '')
                product = int(row.get('product', ''))
                description = int(row.get('description', ''))
                published_date = row.get('published_date', '')
                vector_string = row.get('vector_string', '')
                base_score = row.get('base_score', '')
                impact_score = row.get('impact_score', '')
                exploitability_score = row.get('exploitability_score', '')

                post = CveVulnerabilities(cve_id, link, vendor, product, description, published_date, vector_string. vector_string, base_score, impact_score, exploitability_score)
                vulnerabilities.append(post)

            except ValueError:
                continue

    return news_list, points_list

file_path = Path('./data/vulnerability_data.csv')
vulnerabilities = all_vulnerabilities(file_path)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/v1.0/vulnerabilities', methods=['GET'])
def all_vulnerabilities():
    return jsonify(vulnerabilities)

if __name__ == '__main__':
    app.run(debug=False)