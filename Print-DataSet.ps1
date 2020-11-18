Param(
    [Parameter(Position=0,Mandatory=$True)]
    [System.Data.DataSet]
    $dataSet
)

foreach($table in $dataSet.Tables)
{
    Write-Host $table

    foreach($row in $table.Rows)
    {
        for($columnIndex=0; $columnIndex -lt $table.Columns.Count; $columnIndex++)
        {
            $column = $table.Columns[$columnIndex]
            $item = $row.ItemArray[$columnIndex]
            Write-Host $column " - " $item
        }
    }
}
