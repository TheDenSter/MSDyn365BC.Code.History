﻿// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

codeunit 130019 "Test User Permissions Subscbr."
{
    EventSubscriberInstance = Manual;

    var
        CanManageUserSecIDs: List of [Guid];

    /// <summary>
    /// Sets the user who shall be mocked as having the previlege to manage users on tenant.
    /// Uses <see cref="OnCanManageUsersOnTenant"/> event.
    /// </summary>
    /// <param name="NewCanManageUserSecID">The security ID of the user that will be able to manage users.</param>
    [Scope('OnPrem')]
    procedure SetCanManageUser(NewCanManageUserSecID: Guid)
    begin
        CanManageUserSecIDs.Add(NewCanManageUserSecID);
    end;

    /// <summary>
    /// Mock the user that can manage users on tenant.
    /// </summary>
    /// <param name="UserSID">The user ID that will be able to manage other users.</param>
    /// <param name="Result">The result of the event that shall determine if the given user has the necessary previleges.</param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"User Permissions Impl.", 'OnCanManageUsersOnTenant', '', false, false)]
    local procedure OnCanManageUsersOnTenant(UserSID: Guid; var Result: Boolean)
    begin
        if CanManageUserSecIDs.Contains(UserSID) then
            Result := true;
    end;
}

