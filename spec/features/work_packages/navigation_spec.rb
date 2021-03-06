#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

RSpec.feature 'Work package navigation', selenium: true do
  let(:user) { FactoryGirl.create(:admin) }
  let(:project) { FactoryGirl.create(:project) }
  let(:work_package) { FactoryGirl.build(:work_package, project: project) }

  before do
    login_as(user)
    work_package.save!
  end

  scenario 'all different angular based work package views', js: true do
    # deep link global work package index
    global_work_packages = Pages::WorkPackagesTable.new
    global_work_packages.visit!

    global_work_packages.expect_work_package_listed(work_package)

    # open details pane for work package

    split_work_package = global_work_packages.open_split_view(work_package)

    split_work_package.expect_subject
    split_work_package.expect_current_path

    # open work package full screen

    full_work_package = global_work_packages.open_full_screen(work_package)

    full_work_package.expect_subject
    full_work_package.expect_current_path

    # deep link work package details pane

    split_work_package.visit!
    split_work_package.expect_subject

    # deep link work package show

    full_work_package.visit!
    full_work_package.expect_subject

    # deep link project work packages

    project_work_packages = Pages::WorkPackagesTable.new(project)
    project_work_packages.visit!

    project_work_packages.expect_work_package_listed(work_package)

    # open project work package details pane

    split_project_work_package = project_work_packages.open_split_view(work_package)

    split_project_work_package.expect_subject
    split_project_work_package.expect_current_path

    # open work package full screen

    full_work_package = project_work_packages.open_full_screen(work_package)

    full_work_package.expect_subject
    full_work_package.expect_current_path

    # Safeguard: ensure spec to have finished loading everything before proceeding to the next spec
    full_work_package.ensure_page_loaded
  end
end
