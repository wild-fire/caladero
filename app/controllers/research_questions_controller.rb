class ResearchQuestionsController < ApplicationController

  def show
    @research_question = ResearchQuestion.includes(question_references: :paper).friendly.find(params[:id])
  end

end
