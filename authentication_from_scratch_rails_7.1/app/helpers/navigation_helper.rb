module NavigationHelper
  def navigation_items
    {
      Home: root_path,
      Calendar: calendar_path,
      Projects: projects_path,
      Tasks: tasks_path,
      Announcements: announcements_path
    }
  end
end
