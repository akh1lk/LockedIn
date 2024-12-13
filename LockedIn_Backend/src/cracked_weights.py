#Ranking Weights Database
college_weightings = {
    "Princeton University": 100,
    "Massachusetts Institute of Technology": 99,
    "Harvard University": 98,
    "Stanford University": 97,
    "Yale University": 96,
    "California Institute of Technology": 95,
    "Duke University": 95,
    "Johns Hopkins University": 95,
    "Northwestern University": 95,
    "University of Pennsylvania": 90,
    "Cornell University": 89,
    "University of Chicago": 89,
    "Brown University": 87,
    "Columbia University": 87,
    "Dartmouth College": 85,
    "University of California--Los Angeles": 85,
    "University of California, Berkeley": 83,
    "Rice University": 82,
    "University of Notre Dame": 82,
    "Vanderbilt University": 82,
    "Carnegie Mellon University": 79,
    "University of Michigan--Ann Arbor": 79,
    "Washington University in St. Louis": 79,
    "Emory University": 77,
    "Georgetown University": 77,
    "University of Virginia": 77,
    "University of North Carolina--Chapel Hill": 73,
    "University of Southern California": 73,
    "University of California, San Diego": 71,
    "New York University": 70,
    "University of Florida": 70,
    "The University of Texas--Austin": 70,
    "Georgia Institute of Technology": 67,
    "University of California, Davis": 67,
    "University of California--Irvine": 67,
    "University of Illinois Urbana-Champaign": 67,
    "Boston College": 63,
    "Tufts University": 63,
    "University of California, Santa Barbara": 61,
    "University of Wisconsin--Madison": 61,
    "Boston University": 60,
    "The Ohio State University": 60,
    "Rutgers University--New Brunswick": 60,
    "University of Maryland, College Park": 56,
    "University of Rochester": 56,
    "Lehigh University": 54,
    "Purdue University--Main Campus": 54,
    "University of Georgia": 54,
    "University of Washington": 54,
    "Wake Forest University": 54,
    "Case Western Reserve University": 51,
    "Texas A&M University": 51,
    "Virginia Tech": 51,
    "Florida State University": 50,
    "Northeastern University": 50,
    "University of Minnesota--Twin Cities": 50,
    "William & Mary": 50,
    "North Carolina State University": 46,
    "Stony Brook University--SUNY": 46,
    "University of California, Merced": 46,
    "University of Massachusetts--Amherst": 46,
    "Villanova University": 46,
    "Brandeis University": 44,
    "George Washington University": 44,
    "Michigan State University": 44,
    "The Pennsylvania State University--University Park": 44,
    "Santa Clara University": 44,
    "Tulane University": 44,
    "University of Miami": 44,
    "Rensselaer Polytechnic Institute": 41,
    "University of Connecticut": 41,
    "University of Pittsburgh": 41,
    "Binghamton University--SUNY": 41,
    "Indiana University--Bloomington": 41,
    "Syracuse University": 41,
    "Colorado School of Mines": 40,
    "Stevens Institute of Technology": 40,
    "University at Buffalo--SUNY": 40,
    "University of California, Riverside": 40,
    "Clemson University": 40,
    "Pepperdine University": 40,
    "Rutgers University--Newark": 40,
    "University of Illinois--Chicago": 40,
    "New Jersey Institute of Technology": 36,
    "University of California, Santa Cruz": 36,
    "Drexel University": 36,
    "Howard University": 36,
    "Marquette University": 36,
    "University of Delaware": 36,
    "Worcester Polytechnic Institute": 36,
    "American University": 35,
    "Baylor University": 35,
    "Fordham University": 35,
    "Loyola Marymount University": 35,
    "Rochester Institute of Technology": 35,
    "Southern Methodist University": 35,
    "University of South Florida": 35,
    "Florida International University": 30,
    "Gonzaga University": 30,
    "Rutgers University--Camden": 30,
    "Temple University": 30,
    "University of Colorado Boulder": 30,
    "University of Iowa": 30,
    "Yeshiva University": 30,
    "Auburn University": 25,
    "Illinois Institute of Technology": 25,
    "Saint Louis University": 25,
    "Texas Christian University": 25,
    "Brigham Young University": 25,
    "California State University--Long Beach": 20,
    "George Mason University": 20,
    "San Diego State University": 20,
    "University of Arizona": 20,
    "University of Missouri": 20,
    "University of New Hampshire": 20,
    "University of Oregon": 20,
    "University of San Diego": 20,
    "University of San Francisco": 20,
    "University of Tennessee--Knoxville": 20,
    "The University of Texas--Dallas": 20,
    "Arizona State University": 10,
    "Chapman University": 10,
    "Creighton University": 10,
}

major_weightings = {
    "Computer Science": 100,
    "Engineering": 95,
    "Data Science": 93,
    "Artificial Intelligence": 92,
    "Biomedical Engineering": 91,
    "Business Administration": 90,
    "Finance": 88,
    "Economics": 87,
    "Physics": 86,
    "Mathematics": 85,
    "Statistics": 84,
    "Cybersecurity": 83,
    "Environmental Science": 82,
    "Chemical Engineering": 81,
    "Mechanical Engineering": 80,
    "Electrical Engineering": 80,
    "Aerospace Engineering": 79,
    "Civil Engineering": 78,
    "Architecture": 77,
    "Biology": 75,
    "Chemistry": 74,
    "Information Science": 73,
    "Operations Research": 72,
    "Materials Science": 71,
    "Industrial Engineering": 70,
    "Management Information Systems": 69,
    "Supply Chain Management": 68,
    "Marketing": 67,
    "Accounting": 66,
    "Human Resources": 65,
    "International Business": 64,
    "Health Informatics": 63,
    "Public Health": 62,
    "Environmental Engineering": 61,
    "Agricultural Engineering": 60,
    "Marine Biology": 59,
    "Geology": 58,
    "Astronomy": 57,
    "Pharmacy": 56,
    "Nursing": 55,
    "Political Science": 54,
    "Psychology": 53,
    "Sociology": 52,
    "Anthropology": 51,
    "Education": 50,
    "English": 50,
    "History": 50,
    "Fine Arts": 50,
    "Performing Arts": 50,
    "Philosophy": 50,
    "Religious Studies": 50,
    "Other": 50,
}

companies_weightings = {
    # Technology Companies
    "Apple": 100,
    "Microsoft": 100,
    "Google (Alphabet Inc.)": 100,
    "Amazon": 95,
    "Meta (Facebook)": 95,
    "Nvidia": 95,
    "Tesla": 90,
    "IBM": 85,
    "Intel": 85,
    "Cisco": 80,
    "Oracle": 80,
    "Salesforce": 80,
    "Adobe": 75,
    "Netflix": 75,
    "Uber": 70,
    "Airbnb": 70,
    "SpaceX": 70,
    "Palantir": 65,
    "Snap Inc.": 65,
    "Twitter": 60,
    "Lyft": 60,
    "Pinterest": 55,
    "Dropbox": 55,
    "Spotify": 50,

    # Finance Companies
    "Goldman Sachs": 100,
    "J.P. Morgan": 100,
    "Morgan Stanley": 100,
    "Blackstone": 95,
    "Citigroup": 95,
    "Bank of America Merrill Lynch": 95,
    "Barclays": 90,
    "Credit Suisse": 90,
    "Deutsche Bank": 85,
    "UBS": 85,
    "Wells Fargo": 80,
    "HSBC": 80,
    "Lazard": 75,
    "Rothschild & Co": 75,
    "Evercore": 70,
    "Jefferies": 70,
    "Raymond James": 65,
    "Nomura": 65,
    "Macquarie": 60,
    "Houlihan Lokey": 60,
    "Moelis & Company": 55,
    "Piper Sandler": 55,
    "Stifel Financial": 50,

    # Consulting Firms
    "McKinsey & Company": 100,
    "Boston Consulting Group (BCG)": 100,
    "Bain & Company": 100,
    "Deloitte": 95,
    "PwC": 95,
    "Ernst & Young (EY)": 95,
    "KPMG": 90,
    "Accenture": 90,
    "Oliver Wyman": 85,
    "Roland Berger": 85,
    "LEK Consulting": 80,
    "AlixPartners": 80,
    "Capgemini": 75,
    "Booz Allen Hamilton": 75,
    "Mercer": 70,
    "A.T. Kearney": 70,
    "ZS Associates": 65,
    "Simon-Kucher & Partners": 65,
    "FTI Consulting": 60,
    "Navigant Consulting": 60,
    "Grant Thornton": 55,
    "Protiviti": 55,
    "Willis Towers Watson": 50,

    # Healthcare and Pharmaceutical Companies
    "Johnson & Johnson": 100,
    "Pfizer": 95,
    "Merck & Co.": 95,
    "Novartis": 90,
    "Roche": 90,
    "GlaxoSmithKline (GSK)": 85,
    "Sanofi": 85,
    "AstraZeneca": 80,
    "AbbVie": 80,
    "Bristol-Myers Squibb": 75,
    "Eli Lilly and Company": 75,
    "Amgen": 70,
    "Biogen": 70,
    "Moderna": 65,
    "Regeneron Pharmaceuticals": 65,
    "Gilead Sciences": 60,
    "Bayer": 60,
    "Takeda Pharmaceutical": 55,
    "CSL Limited": 55,
    "Novo Nordisk": 50,

    # Manufacturing and Industrial Companies
    "General Electric": 100,
    "Siemens": 95,
    "Honeywell": 95,
    "3M": 90,
    "Caterpillar": 90,
    "Boeing": 85,
    "Lockheed Martin": 85,
    "Raytheon Technologies": 80,
    "Northrop Grumman": 80,
    "General Motors": 75,
    "Ford Motor Company": 75,
    "United Technologies": 70,
    "Schneider Electric": 70,
    "ABB": 65,
    "Emerson Electric": 65,
    "Eaton": 60,
    "Parker Hannifin": 60,
    "Rockwell Automation": 55,
    "Cummins": 55,
    "Textron": 50,

    # Consumer Goods Companies
    "Procter & Gamble": 100,
    "Unilever": 95,
    "Nestlé": 95,
    "Coca-Cola": 90,
    "PepsiCo": 90,
    "L'Oréal": 85,
    "Nike": 85,
    "Colgate-Palmolive": 80,
    "Kimberly-Clark": 80,
    "Johnson & Johnson": 75,
    "Mondelez International": 75,
    "General Mills": 70,
    "Kellogg's": 70,
    "Mars, Incorporated": 65,
    "The Estée Lauder Companies": 65,
    "Reckitt Benckiser": 60,
    "Danone": 60,
    "Heineken": 55,
    "Diageo": 55,
    "Anheuser-Busch InBev": 50,

    # Energy Companies
    "ExxonMobil": 100,
    "Chevron": 95,
    "Royal Dutch Shell": 95,
    "BP": 90,
    "TotalEnergies": 90,
    "ConocoPhillips": 85,
    "Schlumberger": 85,
    "Halliburton": 80,
    "Baker Hughes": 80,
    "Marathon Petroleum": 75,
    "Phillips 66": 75,
    "Valero Energy": 70,
    "Occidental Petroleum": 70,
    "Devon Energy": 65,
    "EOG Resources": 65,
    "Pioneer Natural Resources": 60,
    "Hess Corporation": 60,
    "Apache Corporation": 55,
    "Chesapeake Energy": 55,
    "Murphy Oil": 50,

    # Retail Companies
    "Walmart": 100,
    "Amazon": 95,
    "Costco Wholesale": 95,
    "The Home Depot": 90,
    "Target": 90,
    "Best Buy": 85,
    "Lowe's": 85,
    "Walgreens Boots Alliance": 80,
    "CVS Health": 80,
    "Kroger": 75,
}

high_paying_roles_weightings = {
    # STEM Roles
    "Software Engineer": 100,
    "Data Scientist": 98,
    "Machine Learning Engineer": 97,
    "Artificial Intelligence Engineer": 96,
    "Cloud Engineer": 95,
    "Full Stack Developer": 94,
    "Cybersecurity Analyst": 93,
    "DevOps Engineer": 92,
    "Product Manager (Tech)": 91,
    "Solutions Architect": 90,
    "Blockchain Developer": 89,
    "Site Reliability Engineer": 88,
    "Electrical Engineer": 85,
    "Mechanical Engineer": 83,

    # Finance Roles
    "Investment Banker": 100,
    "Hedge Fund Analyst": 99,
    "Private Equity Analyst": 98,
    "Quantitative Analyst": 97,
    "Venture Capital Associate": 96,
    "Financial Analyst": 95,
    "Corporate Finance Manager": 93,
    "Portfolio Manager": 92,
    "Risk Manager": 91,
    "Wealth Manager": 90,
    "Equity Research Analyst": 88,

    # Consulting Roles
    "Management Consultant": 100,
    "Strategy Consultant": 98,
    "Financial Consultant": 96,
    "Operations Consultant": 94,
    "Technology Consultant": 92,
    "Human Resources Consultant": 90,
    "Healthcare Consultant": 88,
    "IT Consultant": 85,

    # Healthcare & Pharma Roles
    "Surgeon": 100,
    "Physician": 98,
    "Pharmacist": 96,
    "Biotech Research Scientist": 94,
    "Clinical Trial Manager": 92,
    "Healthcare Administrator": 90,

    # Business Roles
    "Chief Executive Officer (CEO)": 100,
    "Chief Financial Officer (CFO)": 98,
    "Chief Operating Officer (COO)": 96,
    "Chief Technology Officer (CTO)": 96,
    "Chief Marketing Officer (CMO)": 95,
    "Marketing Director": 93,
    "Sales Director": 92,
    "Operations Manager": 90,

    # Other High-Paying Roles
    "Attorney (Corporate Law)": 98,
    "Patent Lawyer": 97,
    "Economist": 96,
    "Actuary": 95,
    "Real Estate Developer": 93,
    "Architect (Senior)": 91,
    "Airline Pilot": 90,
    "Creative Director (Media/Design)": 88,
    "UX Designer (Senior)": 87,
}