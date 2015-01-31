class ResearchQuestionsController < ApplicationController

  def show
    @research_question = ResearchQuestion.includes(question_references: { paper: :authors }).friendly.find(params[:id])
  end

end
