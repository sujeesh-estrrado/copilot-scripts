import sys
import re

def add_org_id_to_proc(sql_text):
    # Add @organization_id to parameter list
    def add_param(match):
        params = match.group(1).strip()
        # Add comma if needed
        if params and not params.endswith(','):
            params += ','
        params += '\n@organization_id bigint'
        return f'(\n{params}\n)'

    # Add Organization_Id = @organization_id to WHERE clause
    def add_org_id_to_where(match):
        where_clause = match.group(0)
        # Insert the new condition before the last closing parenthesis of the WHERE clause
        # Find the last occurrence of 'and' or ')' before the end of the where clause
        # We'll just add it as a new AND at the end for simplicity
        if 'Organization_Id' not in where_clause:
            where_clause = re.sub(r'(where\s+)', r'\1Organization_Id = @organization_id and ', where_clause, flags=re.IGNORECASE)
        return where_clause

    # Update parameter list in CREATE/ALTER PROCEDURE
    sql_text = re.sub(
        r'\(\s*([\s\S]*?)\s*\)',
        add_param,
        sql_text,
        count=1
    )

    # Update WHERE clause in SELECT statements
    sql_text = re.sub(
        r'where\s+',
        add_org_id_to_where,
        sql_text,
        flags=re.IGNORECASE
    )

    return sql_text

if __name__ == "__main__":
    input_sql = sys.stdin.read()
    output_sql = add_org_id_to_proc(input_sql)
    print(output_sql)