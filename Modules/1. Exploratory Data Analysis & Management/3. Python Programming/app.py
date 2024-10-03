from flask import Flask, jsonify, render_template
from pathlib import Path
import csv
import json
import statistics

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

def get_all_vulnerabilities(file_path):
    vulnerabilities = []
    with open(file_path, 'r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            try:
                cve_id = row.get('Cve_Id', '0')
                link = row.get('Link', '')
                vendor = row.get('Vendor', '')
                product = row.get('Product', '')
                description = row.get('Description', '')
                year = row.get('Year', '')
                published_date = row.get('Published_Date', '')
                vector_string = row.get('Vector_String', '')
                base_score = row.get('Base_Score', '')
                impact_score = row.get('Impact_Score', '')
                exploitability_score = row.get('Exploitability_Score', '')

                post = CveVulnerabilities(cve_id, link, vendor, product, description, year, published_date, vector_string, base_score, impact_score, exploitability_score)
                vulnerabilities.append(post)

            except ValueError:
                continue
    return vulnerabilities

def calculate_statistics(vulnerabilities):
    
    def safe_float(value):
        try:
            return float(value)
        except (ValueError, TypeError):
            return None

    base_scores = [safe_float(vuln.base_score) for vuln in vulnerabilities if safe_float(vuln.base_score) is not None]
    impact_scores = [safe_float(vuln.impact_score) for vuln in vulnerabilities if safe_float(vuln.impact_score) is not None]
    exploitability_scores = [safe_float(vuln.exploitability_score) for vuln in vulnerabilities if safe_float(vuln.exploitability_score) is not None]

    statistics_data = {
        'base_score': {
            'mean': statistics.mean(base_scores) if base_scores else None,
            'median': statistics.median(base_scores) if base_scores else None,
            'mode': statistics.mode(base_scores) if base_scores else None
        },
        'impact_score': {
            'mean': statistics.mean(impact_scores) if impact_scores else None,
            'median': statistics.median(impact_scores) if impact_scores else None,
            'mode': statistics.mode(impact_scores) if impact_scores else None
        },
        'exploitability_score': {
            'mean': statistics.mean(exploitability_scores) if exploitability_scores else None,
            'median': statistics.median(exploitability_scores) if exploitability_scores else None,
            'mode': statistics.mode(exploitability_scores) if exploitability_scores else None
        }
    }

    return statistics_data

file_path = Path('./data/vulnerability_data.csv')
all_vulnerabilities = get_all_vulnerabilities(file_path)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/v1.0/vulnerabilities', methods=['GET'])
def vulnerabilities():

    def safe_float(value):
        try:
            return float(value)
        except (ValueError, TypeError):
            return None

    sorted_vulnerabilities = sorted(
        [vuln for vuln in all_vulnerabilities if safe_float(vuln.base_score) is not None], 
        key=lambda v: safe_float(v.base_score), 
        reverse=True
    )

    top_10_vulnerabilities = sorted_vulnerabilities[:10]

    serialized_vulnerabilities = [vuln.to_dict() for vuln in top_10_vulnerabilities]

    return jsonify(serialized_vulnerabilities)

@app.route('/api/v1.0/statistics', methods=['GET'])
def statistics_route():
    stats = calculate_statistics(all_vulnerabilities)
    return jsonify(stats)
@app.route('/api/v1.0/points-stats', methods=['GET'])

def points_stats():

    base_scores = [vuln.base_score for vuln in all_vulnerabilities if vuln.base_score]
    mean_value = statistics.mean(base_scores)
    median_value = statistics.median(base_scores)
    mode_value = statistics.mode(base_scores)
    std_value = statistics.stdev(base_scores)

    return jsonify({
        'mean': mean_value,
        'median': median_value,
        'mode': mode_value,
        'std': std_value,
        'values': base_scores
    })
    
if __name__ == '__main__':
    app.run(debug=False)