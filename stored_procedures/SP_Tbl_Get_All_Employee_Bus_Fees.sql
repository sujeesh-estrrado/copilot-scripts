IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Get_All_Employee_Bus_Fees]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Get_All_Employee_Bus_Fees]
        @Department_Id bigint,
        @Month Datetime
        AS
        BEGIN

            SELECT 
                DISTINCT 
                E.Employee_Id AS Id,
                Employee_FName + '' '' + Employee_LName AS [Name],
                Route_Stop_Name,
                ta.Joining_Date,
                ISNULL(CAST(tfd.Transport_Fees_Detail_Id AS varchar(100)), ''0'') AS Transport_Fees_Detail_Id,
                ISNULL(CAST(tfd.Transport_Fees_Id AS varchar(100)), ''0'') AS Transport_Fees_Id,
                tr.Amount,
                (tr.Amount - ISNULL(tfd.Amount, 0)) AS BalanceAmount,
                tr.RouteStopId,
                CASE 
                    WHEN tfd.Amount IS NULL THEN 0 -- not settled
                    WHEN tfd.Amount = tr.Amount THEN 1 -- fully settled
                    ELSE 2 
                END AS PaymentStatus -- partially settled
            FROM 
                Tbl_Transport_Admission ta
            INNER JOIN Tbl_Transport_Route_Fee tr ON tr.RouteStopId = ta.RouteStopId
            INNER JOIN Tbl_Employee E ON ta.Student_Employee_Id = E.Employee_Id AND Student_Employee_Status = 1
            INNER JOIN Tbl_Employee_Official EO ON E.Employee_Id = EO.Employee_Id
            INNER JOIN Tbl_Route_Settings rs ON rs.Route_Set_Id = tr.RouteStopId
            LEFT JOIN Tbl_Transport_Fees_Details tfd ON tfd.RouteFeeId = tr.RouteFeeId 
                AND tfd.Delete_Status = 0 
                AND [Month] = @Month 
                AND E.Employee_Id = (
                    SELECT StudentOrEmployee_Id 
                    FROM Tbl_Transport_Fees 
                    WHERE Transport_Fees_Id = tfd.Transport_Fees_Id
                )
            WHERE 
                (@Month BETWEEN FromDate AND ToDate) 
                AND Department_Id = @Department_Id 
                AND (DATEPART(MM, @Month) BETWEEN DATEPART(MM, Joining_Date) AND ISNULL(DATEPART(MM, Leaving_Date), DATEPART(MM, GETDATE())))
                AND (DATEPART(YYYY, @Month) BETWEEN DATEPART(YYYY, Joining_Date) AND ISNULL(DATEPART(YYYY, Leaving_Date), DATEPART(YYYY, GETDATE())))
            ORDER BY [Name] ASC

        END
    ')
END
