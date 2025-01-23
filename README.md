<h2>Project Contents</h2>
<ul>
    <li><strong>Dataset</strong>: A CSV file containing Netflix data (e.g., movies, TV shows, genres, release years, ratings, etc.).</li>
    <li><strong>Queries</strong>: <code>queries.sql</code> file with pre-written SQL queries for data analysis and reporting.</li>
    <li><strong>Schema</strong>: <code>schema.sql</code> file for creating the database structure, including tables, relationships, and constraints.</li>
</ul>

<h2>Features</h2>
<ul>
    <li><strong>Database Schema</strong>: Well-structured schema with normalized tables and relationships.</li>
    <li><strong>Data Analysis</strong>: SQL queries for insights like most popular genres, top-rated content, and trends over time.</li>
    <li><strong>Compatibility</strong>: The project is compatible with major database management systems (e.g., MySQL, PostgreSQL).</li>
</ul>

<h2>Installation</h2>
<ol>
    <li><strong>Clone the repository</strong>:
        <pre><code>git clone https://github.com/your-username/netflix-database.git</code></pre>
    </li>
    <li><strong>Set up the database</strong>:
        <ul>
            <li>Open your preferred database management tool (e.g., MySQL Workbench, pgAdmin).</li>
            <li>Run the <code>schema.sql</code> file to create the database and tables:</li>
            <pre><code>SOURCE schema.sql;</code></pre>
        </ul>
    </li>
    <li><strong>Import the dataset</strong>:
        <p>Use the database tool or a command-line utility to import the CSV file into the appropriate table. For example:</p>
        <pre><code>LOAD DATA INFILE 'path_to_your_csv_file.csv'
