﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace Microsoft.Finance.Analysis;

codeunit 692 "Paym. Prac. Cust. Generator" implements PaymentPracticeDataGenerator
{
    Access = Internal;

    procedure GenerateData(var PaymentPracticeData: Record "Payment Practice Data"; PaymentPracticeHeader: Record "Payment Practice Header")
    var
        PaymentPracticeBuilders: Codeunit "Payment Practice Builders";
    begin
        PaymentPracticeBuilders.BuildPaymentPracticeDataForCustomer(PaymentPracticeData, PaymentPracticeHeader);
    end;
}
